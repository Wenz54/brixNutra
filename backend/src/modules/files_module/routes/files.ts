import { FastifyInstance } from 'fastify';
import { pipeline } from 'stream/promises';
import fs from 'fs';
import path from 'path';
import { promisify } from 'util';

const mkdir = promisify(fs.mkdir);

export async function filesRoutes(fastify: FastifyInstance) {
  // Ensure uploads directory exists
  const uploadsDir = path.join(process.cwd(), 'uploads');
  try {
    await mkdir(uploadsDir, { recursive: true });
  } catch (err) {
    // Directory already exists
  }

  fastify.post('/files/upload', {
    schema: {
      description: 'Upload file',
      tags: ['Files'],
      security: [{ bearerAuth: [] }],
      consumes: ['multipart/form-data'],
    },
    handler: async (request, reply) => {
      try {
        const data = await request.file();
        
        if (!data) {
          return reply.status(400).send({ success: false, error: 'No file provided' });
        }

        // Generate unique filename
        const timestamp = Date.now();
        const originalName = data.filename;
        const ext = path.extname(originalName);
        const filename = `${timestamp}${ext}`;
        const filepath = path.join(uploadsDir, filename);

        // Save file
        await pipeline(data.file, fs.createWriteStream(filepath));

        // Return file URL
        const fileUrl = `/uploads/${filename}`;

        fastify.log.info(`✅ File uploaded: ${filename}`);

        return reply.send({
          success: true,
          data: {
            filename,
            originalName,
            url: fileUrl,
            size: fs.statSync(filepath).size,
          },
        });
      } catch (error) {
        fastify.log.error('Error uploading file:', error);
        throw error;
      }
    },
  });

  fastify.post('/files/upload-multiple', {
    schema: {
      description: 'Upload multiple files',
      tags: ['Files'],
      security: [{ bearerAuth: [] }],
      consumes: ['multipart/form-data'],
    },
    handler: async (request, reply) => {
      try {
        const files = await request.saveRequestFiles();
        
        if (!files || files.length === 0) {
          return reply.status(400).send({ success: false, error: 'No files provided' });
        }

        const uploadedFiles = files.map((file: any) => {
          const filename = path.basename(file.filepath);
          return {
            filename,
            originalName: file.filename,
            url: `/uploads/${filename}`,
            size: file.file.bytesRead,
          };
        });

        fastify.log.info(`✅ ${files.length} files uploaded`);

        return reply.send({
          success: true,
          data: uploadedFiles,
        });
      } catch (error) {
        fastify.log.error('Error uploading files:', error);
        throw error;
      }
    },
  });

  // Serve uploaded files
  fastify.register(require('@fastify/static'), {
    root: uploadsDir,
    prefix: '/uploads/',
  });

  fastify.log.info('✅ Files routes registered');
}

