import request from '@/utils/request'

export const searchPromptList = (params) => {
  return request({
    url: '/ai/api/prompts/search',
    method: 'get',
    params
  })
}
