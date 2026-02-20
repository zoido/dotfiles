# Navigate to git repository root directory.
function grt --description 'cd to git root directory'
    cd (git rev-parse --show-toplevel; or echo .)
end
