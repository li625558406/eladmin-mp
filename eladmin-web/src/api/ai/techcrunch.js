import request from '@/utils/request'

export function searchTechCrunchNews(params) {
  return request({
    url: '/ai/api/techcrunch/news',
    method: 'get',
    params
  })
}

export function getTechCrunchNewsDetail(newsId) {
  return request({
    url: `/ai/api/techcrunch/news/${newsId}`,
    method: 'get'
  })
}

export function getTechCrunchNewsTotal(params) {
  return request({
    url: '/ai/api/techcrunch/news/total',
    method: 'get',
    params
  })
}
