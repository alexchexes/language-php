#!/bin/bash

pnpm run -s regex-builder for-grammar/input/ext.intl.txt --no-split=VALID,STANDARD,TOKEN,VERSION,OPTION,FILTER,PROHIBITED,ACCESS,RULE,OPERATOR > for-grammar/ext.intl.re

pnpm run -s regex-builder for-grammar/input/ext.pgsql.txt --no-split=CONNECTION,CONTEXT,AUTH_OK,VERBOSE,LONG,ING > for-grammar/ext.pgsql.re

pnpm run -s regex-builder for-grammar/input/ext.sockets.txt --split=SOCKET_ENOT,SOCKET_ENO,SOCKET_E --no-split=SOCK_,BLOCK,WANT,QUEUE,CTRUNC,TYPE,OOBINLINE,GESTION,ACCEPT,SUPPORT,EMPTY,REMOTE,PERM,STREAM,AGAIN,L2,2BIG,PROGRESS,ACCES,PIPE,LOOP,SIZE,FILE,DIR,IDRM,EXIST,FAULT,START,LONG,RESET,REMCHG,ABORTED,SOL_,COMM,MAX,RNG,IPV,LINK,IPPRO,MEDIUM,NET,INTR,ADDR,DONT,DEBUG,ROFS,EOF --min-word-split 2 > for-grammar/ext.sockets.re

pnpm run -s regex-builder for-grammar/input/ext.sodium.txt --no-split=VERSION,LIMIT,MODERATE,SENSITIVE,MAJOR,KEY,BYTES --split=SODIUM_CRYPTO_AEAD_XCHACHA20POLY1305_IETF_A > for-grammar/ext.sodium.re