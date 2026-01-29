odoo() {
  source ".venv/bin/activate"

  local VERSION="$1"
  shift
  local ODOO_BIN="$HOME/src/gh/odoo/odoo/$VERSION/odoo-bin"
  local CONF=".local/odoo.conf"
  python3 "$ODOO_BIN" "$@" -c "$CONF"
}
