/**
 * Purpose: Jest configuration for leCommit hackathon app tests
 */

module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/test/**/*.test.js'],
  collectCoverageFrom: [
    'server.js',
    '!node_modules/**',
    '!test/**'
  ],
  verbose: true,
  forceExit: true,
  clearMocks: true,
  resetMocks: true,
  testTimeout: 10000
}; 