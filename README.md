USign 1.0.0
-

Verified to be working with:
    **（仅支持2019.4.40f之后的版本，不包括2019.4.40f）**

​     **(通过Unity Hub安装的Unity一般安装位置在C盘，执行时会遇到操作文件权限不够的情况，建议通过安装包安装)**

* 2021.3.23 OSX
* 2022.2.16 Win

Process:

1. Generate keypair and cert with provided `openssl.conf`. Cert size in DER format must be 1267 bytes
2. Replace cert in `Unity.Licensing.EntitlementResolver.dll` using HEX editor or `patch` binary
3. Modify `license.xml` template to your needs
4. Generate `Unity_lic.ulf` signed with private key using `sign` binary
5. `ts.go` is an implementation of `TimeStamp` encoder/decoder just in case.

Usage:

* `patch /path/to/Unity.Licensing.EntitlementResolver.dll`
* `sign`
* `cp Unity_lic.ulf /path/to/license/dir` **（e.g. C:\ProgramData\Unity）**

Block domains in `/etc/hosts`

```
# unity
127.0.0.1 license.unity3d.com
127.0.0.1 core.cloud.unity3d.com
127.0.0.1 activation.unity3d.com
127.0.0.1 cdp.cloud.unity3d.com

# this one seems to be optional
# blocking won't allow signing into Unity ID
127.0.0.1 api.unity.com
```