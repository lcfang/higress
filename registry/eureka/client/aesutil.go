package client

import (
	"crypto/aes"
	"crypto/cipher"
	"encoding/base64"
	"github.com/zenazn/pkcs7pad"
)

const (
	RequestAppHeaderKey       = "x-request-app"
	RequestVersionHeaderKey   = "x-request-version"
	RequestTimestampHeaderKey = "x-request-timestamp"
	RequestTokenHeaderKey     = "x-request-token"
	RequestAppHeaderValue     = "F-DSF"
	RequestVersionHeaderValue = "1.0.0"
)

// fillBytes16 函数，确保 keyBytes 长度为 16 字节
func fillBytes16(keyBytes []byte) []byte {
	newKeyBytes := make([]byte, 16)
	copy(newKeyBytes, keyBytes)
	return newKeyBytes[:16]
}

// Encrypt 实现 AES 加密功能
func Encrypt(needEncryptStr string, key string, iv string) (string, error) {
	keyBytes := fillBytes16([]byte(key))
	ivBytes := fillBytes16([]byte(iv))

	block, err := aes.NewCipher(keyBytes)
	if err != nil {
		return "", err
	}

	plaintext := []byte(needEncryptStr)

	// 使用 PKCS7 填充
	plaintext = pkcs7pad.Pad(plaintext, aes.BlockSize)

	// 使用 CBC 模式加密
	mode := cipher.NewCBCEncrypter(block, ivBytes)

	ciphertext := make([]byte, len(plaintext))
	mode.CryptBlocks(ciphertext, plaintext)

	// Base64 编码
	return base64.StdEncoding.EncodeToString(ciphertext), nil
}
