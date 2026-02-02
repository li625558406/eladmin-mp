import request from '@/utils/request'

export function sendEmailCode(email, type) {
  return request({
    url: '/api/email-code/send',
    method: 'post',
    params: { email, type }
  })
}

export function verifyEmailCode(email, code, type) {
  return request({
    url: '/api/email-code/verify',
    method: 'post',
    params: { email, code, type }
  })
}
