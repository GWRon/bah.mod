' Copyright (c) 2009-2018 Bruce A Henderson
' All rights reserved.
'
' Redistribution and use in source and binary forms, with or without
' modification, are permitted provided that the following conditions are met:
'     * Redistributions of source code must retain the above copyright
'       notice, this list of conditions and the following disclaimer.
'     * Redistributions in binary form must reproduce the above copyright
'       notice, this list of conditions and the following disclaimer in the
'       documentation and/or other materials provided with the distribution.
'     * Neither the auther nor the names of its contributors may be used to 
'       endorse or promote products derived from this software without specific
'       prior written permission.
'
' THIS SOFTWARE IS PROVIDED BY Bruce A Henderson ``AS IS'' AND ANY
' EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
' WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
' DISCLAIMED. IN NO EVENT SHALL Bruce A Henderson BE LIABLE FOR ANY
' DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
' (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
' LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
' ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
' (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
' SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'
SuperStrict

Import BRL.Blitz
Import Pub.zlib
Import BaH.mbedtls

Import "../mbedtls.mod/mbedtls/include/*.h"

?win32
Import "include_win32/*.h"
?Not win32
Import "include_unix/*.h"
?
Import "include_all/*.h"
Import "src/*.h"

Import "src/agent.c"
Import "src/channel.c"
Import "src/comp.c"
Import "src/crypt.c"
Import "src/global.c"
Import "src/hostkey.c"
Import "src/keepalive.c"
Import "src/kex.c"
Import "src/knownhost.c"
Import "src/libgcrypt.c"
Import "src/mac.c"
Import "src/mbedtls.c"
Import "src/misc.c"
Import "src/openssl.c"
Import "src/os400qc3.c"
Import "src/packet.c"
Import "src/pem.c"
Import "src/publickey.c"
Import "src/scp.c"
Import "src/session.c"
Import "src/sftp.c"
Import "src/transport.c"
Import "src/userauth.c"
Import "src/version.c"
Import "src/wincng.c"

Import "glue.cpp"
