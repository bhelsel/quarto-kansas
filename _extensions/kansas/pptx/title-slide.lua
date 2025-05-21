function Meta(meta)
  if meta.author then
    for i, author in ipairs(meta.author) do
      local name = pandoc.Strong{pandoc.Str(pandoc.utils.stringify(author.name or ""))}
      local role  = pandoc.utils.stringify(author.role or "")
      local center = pandoc.utils.stringify(author.center or "")
      local institution = pandoc.utils.stringify(author.institution or "")

      local authorBlock = pandoc.Inlines{}
      authorBlock:insert(name)
      if role ~= "" then authorBlock:insert(pandoc.Str(role)) end
      if center ~= "" then authorBlock:insert(pandoc.Str(center)) end
      if institution ~= "" then authorBlock:insert(pandoc.Str(institution)) end

      meta.author[i] = pandoc.MetaInlines(authorBlock)
    end
  end
  return meta
end
