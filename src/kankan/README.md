
## kankan - Easy integration tests for UNIX folks

Write simple BASH scripts for creating integration tests.

## Configuration in ~/.kankan.conf

```bash
# -*- mode: sh; sh-shell: bash; -*-

declare -Ax ece_instance_host_port_and_http_auth_map=
declare -Ax ece_instance_host_port_and_publication_map=
declare -Ax ece_instance_host_port_and_content_type_map=

ece_instance_host_port_and_http_auth_map=(
  ["banana.example.com"]="foo:bar"
  ["apple.example.com:8080"]="foo:bar"
  ["orange.example.com:8080"]="foo:bar"
  ["localhost:8080"]="mypub_admin:baz"
)

ece_instance_host_port_and_publication_map=(
  ["apple.example.com:8080"]="demopub"
  ["orange.example.com:8080"]="demopub"
  ["localhost:8080"]="mypub"
  ["banana.example.com"]="dev.banana"
)

ece_instance_host_port_and_content_type_map=(
  ["apple.example.com:8080"]="story"
  ["orange.example.com:8080"]="story"
  ["localhost:8080"]="story"
  ["banana.example.com"]="story"
)
```

# Example output
```
$ kankan
E..E......................E.E...E.E.............E..E..............
   ☠ _check_section_page_state_translation http://orange.example.com:8080/webservice/escenic/pool/state/published/editor did not have a German version for locale de
   ☠ _check_section_page_state_translation http://orange.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Norwegian version for locale nb
   ☠ _check_section_page_state_translation http://orange.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Norwegian version for locale no
   ☠ _check_section_page_state_translation http://erd-banana.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Swedish version for locale sv
   ☠ _check_section_page_state_translation http://apple.example.com:8080/webservice/escenic/pool/state/published/editor did not have a German version for locale de
   ☠ _check_section_page_state_translation http://apple.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Norwegian version for locale nb
   ☠ _check_section_page_state_translation http://flowerhatece.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Norwegian version for locale no
   ☠ _check_section_page_state_translation http://flowerhatece.poc.ccieurope.com:8080/webservice/escenic/pool/state/published/editor did not have a Swedish version for locale sv
Tests run: 58; success: 50; error: 8;
```

# Extending

Create a new `check-` file in the `checks` directory. All methods
starting with `check_` will be included in the test suite.

See <a href="checks/check-network.sh">checks/check-network.sh"</a> for
a simple check and <a
href="checks/check-ece-instances.sh">checks/check-ece-instances.sh</a>
for a more advanced example, executing the same tests against multiple
machines.

