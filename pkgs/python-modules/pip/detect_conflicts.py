#!/usr/bin/env python
import json
import sys

package_versions = {}

for file in sys.argv[1:]:
    with open('%s/metadata.json' % file, 'r') as fd:
        data = json.load(fd)
        versions = package_versions.setdefault(data['name'], [])
        versions.append(data['version'])


status = 0

for name, versions in package_versions.items():
    if len(versions) > 1:
        print('error: detected package %s with conflicting versions %s' % (name, ', '.join(versions)))
        status = 1

sys.exit(status)
