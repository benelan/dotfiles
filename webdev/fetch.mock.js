import { examSchemaIsValid, trainingSchemaIsValid } from '../utils/validateData'
/**
 * Mocks API requests, validating the schema
 * For more complicated APIs use:
 * https://mswjs.io/docs/getting-started/mocks/rest-api
 */
async function mockFetch(url, config) {
  switch (url) {
  case '/api/logTrainingRequest': {
    const trainingData = JSON.parse(config.body)
    if (trainingSchemaIsValid(trainingData)) {
      return {
        ok: true,
        status: 200,
        json: async () => ({ message: 'training log successful' }),
      }
    }
    return {
      ok: false,
      status: 400,
      json: async () => ({ message: 'invalid training data schema' }),
    }
  }
  case '/api/logExamRequest': {
    const examData = JSON.parse(config.body)
    if (examSchemaIsValid(examData)) {
      return {
        ok: true,
        status: 200,
        json: async () => ({ message: 'exam log successful' }),
      }
    }
    return {
      ok: false,
      status: 400,
      json: async () => ({ message: 'invalid exam data schema' }),
    }
  }
  default: {
    const err = new Error(`Unhandled request: ${url}`)
    return Promise.reject(err)
  }
  }
}

window.fetch = jest.fn()
window.fetch.mockImplementation(mockFetch)
