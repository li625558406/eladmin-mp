import request from '@/utils/request'
import { encrypt } from '@/utils/rsaEncrypt'

const avatarCount = 15

function getRandomAvatarPath() {
  const index = Math.floor(Math.random() * avatarCount) + 1
  return `/static/avatar/${index}.jpg`
}

export function register(data) {
  return request({
    url: '/api/users/register',
    method: 'post',
    data: {
      username: data.username,
      email: data.email,
      password: encrypt(data.password),
      confirmPassword: encrypt(data.confirmPassword),
      avatarPath: getRandomAvatarPath(),
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
