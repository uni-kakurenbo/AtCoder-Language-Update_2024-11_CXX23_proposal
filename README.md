名前が紛らわしいので `install.toml` はすべて `config.toml` として扱っています．

# About
- `dist/`：提出用の `config.toml` があります．色々展開されたファイルたち．
- `src/`：編集用のソースたち．
- `config/`: コンパイルオプション生成用の pkg-config ファイルたち．
- `test/`：テストコードたち．最低限のもののみ．

# Note
`sub-installer/library/` 内のファイル名は，拡張子 `.sh` を除いて `config.toml` の `library` の key に一致させること．`VERSION` にバージョンが自動的に割り当たる．

# License
以下のディレクトリ内のファイルは [Boost Software License 1.0](https://www.boost.org/doc/user-guide/bsl.html) の下で提供されます：
- `/test/01_boost`

以下のディレクトリ内のファイルは [Creative Commons 1.0](https://creativecommons.org/publicdomain/zero/1.0/) の下で提供されます：
- `/dist`

その他の任意のファイルは [MIT License](https://opensource.org/license/mit) の下で提供されます．
