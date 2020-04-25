Use an external node_modules bundle to workaround node2nix issues.

This package require some preparation steps...

Generate bundle:
```bash
npm install --no-package-lock webtorrent-cli@3.0.0
tar -C node_modules -czf webtorrent-cli-3.0.0.tar.gz .
```

Publish bundle:
```bash
jfrog bt pc --licenses MIT --vcs-url https://github.com/webtorrent/webtorrent-cli  jeremiehuchet/nur-bin/webtorrent-cli
jfrog bt vc jeremiehuchet/nur/webtorrent-cli/3.0.0
jfrog bt u webtorrent-cli-3.0.0.tar.gz jeremiehuchet/nur-bin/webtorrent-cli/3.0.0
jfrog bt vp jeremiehuchet/nur-bin/test/3.0.0
```