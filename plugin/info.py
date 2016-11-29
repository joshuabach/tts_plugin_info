#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import urlparse
import json
import base64
import random
import string
import sys
import traceback
import time

def list_params():
    RequestParams = []
    ConfParams = []
    return json.dumps({'result':'ok', 'conf_params': ConfParams, 'request_params': RequestParams, 'version':'dev'})

def request_info(JObject):
    Credential = info_to_credential(JObject)
    return json.dumps({'result':'ok', 'credential': Credential, 'state': 'user_info'})

def info_to_credential(JObject):
    Version = JObject['tts_version']
    UserId = JObject['tts_userid']
    UserInfo = JObject['user_info']
    UserId_data = str(UserId)+ '=' * (4 - len(UserId) % 4)
    DecodedUserId = str(base64.urlsafe_b64decode(UserId_data))
    OidcCredential = [
        {'name':'TTS version', 'type':'text', 'value':Version},
        {'name':'TTS userid', 'type':'text', 'value':UserId},
        {'name':'TTS userid (decoded)', 'type':'text', 'value':DecodedUserId}]

    for Key in UserInfo:
        KeyName = oidc_key_to_name(Key)
        Type = oidc_key_to_type(Key)
        Name = "%s"%KeyName
        Value = UserInfo[Key]
        NewObj = [{'name':Name, 'type':Type, 'value':Value  }]
        OidcCredential = OidcCredential + NewObj

    Json = json.dumps(JObject, sort_keys=True, indent=4, separators=(',',': '))
    WholeJsonObject = [{'name':'json object', 'type':'textarea', 'value':Json}]
    OidcCredential = OidcCredential + WholeJsonObject
    return OidcCredential

def oidc_key_to_name(Key):
    if Key == "iss":
        return "Issuer"
    if Key == "sub":
        return "Subject"
    if Key == "name":
        return "Name"
    if Key == "groups":
        return "Groups"
    if Key == "email":
        return "E-Mail"
    if Key == "gender":
        return "Gender"
    return Key


def oidc_key_to_type(Key):
    if Key == "groups":
        return "textarea"
    return "text"

def revoke_info():
    return json.dumps({'result': 'ok'})


def main():
    try:
        UserMsg = "Internal error, please contact the administrator"

        if len(sys.argv) == 2:
            Json = str(sys.argv[1])+ '=' * (4 - len(sys.argv[1]) % 4)
            JObject = json.loads(str(base64.urlsafe_b64decode(Json)))
            Action = JObject['action']
            if Action == "parameter":
                print list_params()
            elif Action == "request":
                print request_info(JObject)
            elif Action == "revoke":
                print revoke_info()
            else:
                print json.dumps({"error": "unknown_action", "details": action})
        else:
            print json.dumps({"error": "no_parameter"})
    except Exception, E:
        TraceBack = traceback.format_exc(),
        LogMsg = "the plugin failed with %s - %s"%(str(E), TraceBack)
        print json.dumps({'result':'error', 'user_msg':UserMsg, 'log_msg':LogMsg})

if __name__ == "__main__":
    main()
