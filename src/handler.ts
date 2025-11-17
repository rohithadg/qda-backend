import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { ExpressAdapter } from '@nestjs/platform-express';
import { APIGatewayProxyHandler, APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import * as express from 'express';
import { AppModule } from './app.module';

let app: any;
let server: express.Application;

const createApp = async () => {
  const expressApp = express();
  app = await NestFactory.create(AppModule, new ExpressAdapter(expressApp));
  app.setGlobalPrefix('api');
  await app.init();
  return expressApp;
};

export const handler: APIGatewayProxyHandler = async (
  event: APIGatewayProxyEvent,
): Promise<APIGatewayProxyResult> => {
  if (!server) {
    server = await createApp();
  }

  return new Promise((resolve, reject) => {
    // Create a mock request/response for Express
    const req = {
      method: event.httpMethod,
      url: event.path,
      headers: event.headers || {},
      body: event.body ? Buffer.from(event.body, event.isBase64Encoded ? 'base64' : 'utf8') : Buffer.alloc(0),
      query: event.queryStringParameters || {},
    };

    const res = {
      statusCode: 200,
      headers: {} as Record<string, string>,
      body: '',
      isBase64Encoded: false,
      write: function (chunk: any) {
        this.body += chunk.toString();
      },
      setHeader: function (key: string, value: any) {
        this.headers[key] = value;
      },
      end: function (chunk?: any) {
        if (chunk) {
          this.body += chunk.toString();
        }
        resolve({
          statusCode: this.statusCode,
          headers: this.headers,
          body: this.body,
          isBase64Encoded: this.isBase64Encoded,
        });
      },
      json: function (data: any) {
        this.setHeader('Content-Type', 'application/json');
        this.body = JSON.stringify(data);
      },
    };

    try {
      server(req as any, res as any);
    } catch (error) {
      reject(error);
    }
  });
};
