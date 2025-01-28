from INWX.Domrobot import ApiClient

username = ''
password = ''
domain = ''

api_client = ApiClient(api_url=ApiClient.API_LIVE_URL, debug_mode=True)

login_result = api_client.login(username, password)

if login_result['code'] == 1000:
    record_result = api_client.call_api(api_method='nameserver.list')

    if record_result['code'] == 1000:
        records = record_result['resData']['record']
        with open("../terraform/imports.tf", "a") as f:
            for record in records:
                is_root = record['name'] == domain
                subdomain = record['name'].removesuffix(domain)
                typeName = record['type'].lower()
                isNotIP = typeName != "a" and typeName != "aaaa"
                content = ""
                if isNotIP:
                    content = "_" + record['content']
                if subdomain.endswith("."):
                    subdomain = subdomain[:-1]
                elif subdomain == "":
                    subdomain = "root"
                f.write("\nimport {"
                        + "\nto = inwx_nameserver_record.twomartens_de_" + subdomain + "_" + typeName + content
                        + "\nid = \"" + domain + ":" + str(record['id']) + "\""
                        + "\n}")

    else:
        raise Exception('Api error while fetching records. Code: ' + str(record_result['code'])
                        + '  Message: ' + record_result['msg'])
    api_client.logout()
else:
    raise Exception('Api login error. Code: ' + str(login_result['code']) + '  Message: ' + login_result['msg'])
