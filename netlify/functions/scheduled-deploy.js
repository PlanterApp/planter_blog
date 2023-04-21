import fetch from 'node-fetch'
import { schedule } from '@netlify/functions'

// This is a sample build hook URL
const BUILD_HOOK = 'https://api.netlify.com/build_hooks/6442a4587851e905b1620fe6'

// Schedules the handler function to run every hour of every day
const handler = schedule('10 * * * *', async () => {
  await fetch(BUILD_HOOK, {
    method: 'POST'
  }).then(response => {
    console.log('Build hook response:', response)
  })

  return {
    statusCode: 200
  }
})

export { handler }