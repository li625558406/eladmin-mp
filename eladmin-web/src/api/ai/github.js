import request from '@/utils/request'

export const getGithubProjects = (params) => {
  return request({
    url: '/ai/api/github/projects',
    method: 'get',
    params
  })
}

export const getGithubProjectDetail = (projectId) => {
  return request({
    url: `/ai/api/github/projects/${projectId}`,
    method: 'get'
  })
}
