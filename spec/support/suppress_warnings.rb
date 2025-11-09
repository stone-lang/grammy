# Suppress warnings ONLY when loading pry (which has unfixed Ruby 3.4 warnings)
# This is scoped to just the gem loading, not our own code
# Warnings in Grammy code will still be shown
original_verbose = $VERBOSE
begin
  $VERBOSE = nil
  require "pry"
ensure
  $VERBOSE = original_verbose
end
