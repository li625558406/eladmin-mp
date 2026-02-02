import request from '@/utils/request'
import { encrypt } from '@/utils/rsaEncrypt'

export function register(data) {
  return request({
    url: '/api/user/register',
    method: 'post',
    data: {
      username: data.username,
      email: data.email,
      password: encrypt(data.password),
      code: data.code
    }
  })
}

export function emailLogin(data) {
  return request({
    url: '/auth/email-login',
    method: 'post',
    data: {
      email: data.email,
      code: data.code
    }
  })
}
