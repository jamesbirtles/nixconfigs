# Inline AI completion via Supermaven. Accept with <A-l>, accept a word
# with <A-L>.
{ ... }:
{
  plugins.supermaven = {
    enable = true;
    settings = {
      keymaps = {
        accept_suggestion = "<A-l>";
        accept_word = "<A-L>";
      };
    };
  };
}
