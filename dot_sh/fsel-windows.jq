# Formats niri windows as "<id>\t[<workspace>] <app name> <title>" rows for fsel.
# Inputs: the output of `niri msg -j windows`, with $apps from `fsel --stdout`
# and $workspaces from `niri msg -j workspaces`.

def app_names:
  reduce ($apps[] | select(.desktop_id | contains("#") | not)) as $app ({};
    reduce (
      ($app.desktop_id | sub("\\.desktop$"; "")), ($app.startup_wm_class // empty)
      | ., ascii_downcase
    ) as $key (.; .[$key] //= $app.name));

def pad($width): . + (" " * ($width - length));

app_names as $names
| ($workspaces | map({key: (.id | tostring), value: .}) | from_entries) as $ws
| map(select((.app_id // "") | test("^dev\\.zoid\\.launcher(\\.|$)") | not))
| map(
    (.app_id // "") as $app_id
    | $ws[.workspace_id | tostring] as $w
    | {
        id,
        sort: [($w.idx // 999), (.layout.pos_in_scrolling_layout[0] // 0)],
        workspace: ($w.name // ($w.idx // "?" | tostring)),
        name: ($names[$app_id] // $names[$app_id | ascii_downcase] // $app_id),
        title: (.title // ""),
        focused: .is_focused
      })
| sort_by(.sort)
| (map(.name | length) | max // 0) as $name_width
| (map(.workspace | length) | max // 0) as $ws_width
| .[]
| "\(.id)\t[\(.workspace)]\(" " * ($ws_width - (.workspace | length))) \(.name | pad($name_width)) \(if .focused then "*" else " " end) \(.title)"
