
## kankan - Easy integration tests

Write simple BASH scripts for creating integration tests.

```
$ kankan --help
Usage: kankan OPTIONS

Easy integration tests for the command line.

Reports of each run is stored in /home/torstein/.kankan These can be turned
off with --disable-logs.

OPTIONS
-d, --disable-logs  Don't create log files for each run
-h, --help          This screen.
-p, --print-checks  List all the checks kankan has run
-v, --verbose       Be verbose
```

## Configuration in ~/.kankan.conf

```bash
# -*- mode: sh; sh-shell: bash; -*-

declare -ax url_ok_list=(
  "http://gnu.org"
  "http://skybert.net"
)

declare -Ax ece_instance_host_port_and_http_auth_map=(
  ["banana.example.com"]="foo:bar"
  ["apple.example.com:8080"]="foo:bar"
  ["orange.example.com:8080"]="foo:bar"
  ["localhost:8080"]="mypub_admin:baz"
)

declare -Ax ece_instance_host_port_and_publication_map=(
  ["apple.example.com:8080"]="demopub"
  ["orange.example.com:8080"]="demopub"
  ["localhost:8080"]="mypub"
  ["banana.example.com"]="dev.banana"
)

declare -Ax ece_instance_host_port_and_content_type_map=(
  ["apple.example.com:8080"]="story"
  ["orange.example.com:8080"]="story"
  ["localhost:8080"]="story"
  ["banana.example.com"]="story"
)

declare -ax exclude_check_list=(
  checks/check-that-doesnt-apply-to-me.sh
)
```

# Example output
```
$ kankan
E..E......................E.E...E.E.............E..E..............
   ☠ _check_section_page_state_translation http://orange.example.com:8080/webservice/escenic/pool/state/published/editor did not have a German version for locale de
   ☠ _check_section_page_state_translation http://orange.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Norwegian version for locale nb
   ☠ _check_section_page_state_translation http://orange.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Norwegian version for locale no
   ☠ _check_section_page_state_translation http://orange.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Swedish version for locale sv
   ☠ _check_section_page_state_translation http://apple.example.com:8080/webservice/escenic/pool/state/published/editor did not have a German version for locale de
   ☠ _check_section_page_state_translation http://apple.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Norwegian version for locale nb
   ☠ _check_section_page_state_translation http://apple.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Norwegian version for locale no
   ☠ _check_section_page_state_translation http://apple.example.com:8080/webservice/escenic/pool/state/published/editor did not have a Swedish version for locale sv
Tests run: 58; success: 50; error: 8;
```

# Extending

Create a new `check-` file in the `checks` directory. All methods
starting with `check_` will be included in the test suite.

See <a href="checks/check-network.sh">checks/check-network.sh</a> for
a simple check and <a
href="checks/check-ece-instances.sh">checks/check-ece-instances.sh</a>
for a more advanced example, executing the same tests against multiple
machines.

# What's in a name
`kankan` is Chinese for `look`, or `check` (it out).
