/**
 * Purpose: Basic tests for leCommit hackathon web application
 * Tests core functionality for CI/CD pipeline
 */

const request = require('supertest');
const app = require('../server');

describe('leCommit Hackathon App', () => {
  describe('Health Check', () => {
    it('should return 200 for health endpoint', async () => {
      const res = await request(app).get('/api/health');
      expect(res.status).toBe(200);
      expect(res.body.status).toBe('healthy');
    });
  });

  describe('API Info', () => {
    it('should return app information', async () => {
      const res = await request(app).get('/api/info');
      expect(res.status).toBe(200);
      expect(res.body.name).toBe('leCommit Webapp');
      expect(res.body.version).toBe('1.0.0');
    });
  });

  describe('Data Endpoint', () => {
    it('should handle POST requests to /api/data', async () => {
      const testData = {
        message: 'test message',
        data: { test: 'data' }
      };

      const res = await request(app)
        .post('/api/data')
        .send(testData);

      expect(res.status).toBe(200);
      expect(res.body.response).toBe('Data received successfully!');
      expect(res.body.received.message).toBe('test message');
    });
  });

  describe('Root Endpoint', () => {
    it('should return welcome message', async () => {
      const res = await request(app).get('/');
      expect(res.status).toBe(200);
      expect(res.body.message).toContain('Welcome to leCommit Hackathon App');
    });
  });
}); 