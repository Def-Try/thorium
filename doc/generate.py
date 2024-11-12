import os
import shutil
import json

project = os.getcwd()

home_drive = os.environ["HOMEDRIVE"]
home_path = os.environ["HOMEPATH"]
lua_server_dir = os.path.join(home_drive, home_path, ".vscode", "extensions", "sumneko.lua-*", "server", "bin")

for dirpath, dirnames, filenames in os.walk(os.path.join(home_drive, home_path, ".vscode", "extensions")):
    if "sumneko.lua-" in dirpath:
        lua_server_dir = os.path.join(dirpath, "server", "bin")
        break

if not os.path.isdir(lua_server_dir):
    raise FileNotFoundError(f"Lua language server directory not found: {lua_server_dir}")

doc_dir = os.path.join(project, "doc")
temp_dir = os.path.join(doc_dir, "temp")
if os.path.exists(temp_dir):
    shutil.rmtree(temp_dir)
os.makedirs(temp_dir)

command = f"{lua_server_dir}\\lua-language-server.exe --doc=\"{project}\\lua\" --doc_out_path=\"{temp_dir}\""
os.system(command)
os.remove("./doc/temp/doc.md")

with open("./doc/temp/doc.json", 'r') as f:
    document = json.load(f)

text = ""

from pprint import pprint

def setfield(item, definition):
    text = ""
    if definition['view'] == 'function':
        print(f"setfield\t{item['name']}",end="")
        text += f"# Function `{item['name']}"
        args, returns = None, None
        if definition["extends"].get("args"):
            args = ", ".join(('...' if arg['type'] == '...' else '')+(arg['name']+": "+arg['view'] if arg.get('name') else arg['view']) for arg in definition["extends"]["args"])
        if definition["extends"].get("returns"):
            returns = ", ".join(retun['name']+": "+retun['view'] if retun.get('name') else retun['view'] for retun in definition["extends"]["returns"])
        if args: text += f"({args})"; print(f"({args})",end="")
        else: text += "()"; print("()",end="")
        if returns: text += f" -> {returns}"; print(f" -> {returns}", end='')
        text += "`\n"
        print()
        if definition['extends'].get('rawdesc'):
            text += f"{definition['extends']['rawdesc']}\n"
        text += "\n"
    else:
        print(f"setfield\t{item['name']}: {definition['extends']['view']}")
        text += f"# Field `{item['name']}: {definition['extends']['view']}`\n"
        if definition['extends'].get('rawdesc'):
            text += f"{definition['extends']['rawdesc']}\n"
        text += "\n"
    return text

def setglobal(item, definition):
    text = ""
    if definition['view'] == 'function':
        print(f"setglobal\t{item['name']}",end="")
        text += f"# Function `{item['name']}"
        args, returns = None, None
        if definition["extends"].get("args"):
            args = ", ".join(('...' if arg['type'] == '...' else '')+(arg['name']+": "+arg['view'] if arg.get('name') else arg['view']) for arg in definition["extends"]["args"])
        if definition["extends"].get("returns"):
            returns = ", ".join(retun['name']+": "+retun['view'] if retun.get('name') else retun['view'] for retun in definition["extends"]["returns"])
        if args: text += f"({args})"; print(f"({args})",end="")
        else: text += "()"; print("()",end="")
        if returns: text += f" -> {returns}"; print(f" -> {returns}", end='')
        text += "`\n"
        print()
        if definition['extends'].get('rawdesc'):
            text += f"{definition['extends']['rawdesc']}\n"
        text += "\n"
    else:
        pprint(item)
    return text

def doc_field(item, definition):
    print(f"doc.field\t{item["defines"][0]['view']}.{definition['name']}: {definition['view']}")
    text = ""
    text += f"## `{item["defines"][0]['view']}.{definition['name']}: {definition['view']}`\n\n"
    return text

def _v_function(item, definition):
    print(f"function\t{item['defines'][0]['view']}.{definition['name']}",end="")
    text = ""
    args, returns = None, None
    if definition["extends"].get("args"):
        args = ", ".join(arg['name']+": "+arg['view'] if arg.get('name') else arg['view'] for arg in field["extends"]["args"])
    if definition["extends"].get("returns"):
        returns = ", ".join(retun['name']+": "+retun['view'] if retun.get('name') else retun['view'] for retun in field["extends"]["returns"])
    text += f"## `{item['defines'][0]['view']}.{definition['name']}"
    if args: text += f"({args})"; print(f"({args})",end="")
    else: text += "()"; print("()",end="")
    if returns: text += f" -> {returns}"; print(f" -> {returns}", end='')
    print()
    text += "`\n"
    if definition.get('rawdesc'):
        text += f"{definition['rawdesc']}\n"
    text += "\n"
    return text

def doc_class(item, definition):
    print(f"doc.class\t{definition['view']}")
    text = ""
    text += f"# Class `{definition['view']}`\n"
    if definition.get('rawdesc'):
        text += f"{definition['rawdesc']}\n\n"
    return text

for item in document:
    # if definition["defines"]["file"].startswith("[FORIEGN]"): continue
    if item["defines"][0].get("file", "[FORIEGN]a").startswith("[FORIEGN]"): continue
    definition = item["defines"][0]
    if definition["type"] == "doc.class":
        text += doc_class(item, definition)

        for field in item['fields']:
            if field['view'] == 'function':
                text += _v_function(item, field)
            elif field['type'] == 'setfield':
                text += setfield(item, field)
            elif field['type'] == 'doc.field':
                text += doc_field(item, field)
            else:
                pprint(field)
        text += f"\n\n"
    elif definition['type'] == 'setglobal':
        text += setglobal(item, definition)
    elif definition['type'] == 'setfield':
        text += setfield(item, definition)
    else:
        pprint(item)
text = text.strip()
with open("./doc/template_doc.md", 'w') as f:
    f.write(text)

os.remove("./doc/temp/doc.json")
os.rmdir("./doc/temp")