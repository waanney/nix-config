
{
  home.file.".config/nvim/lua/plugins/comment.lua".text =''
return {
  'numToStr/Comment.nvim',
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
}
    '';
}
