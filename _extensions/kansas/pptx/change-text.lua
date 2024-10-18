-- Thanks to Mickaël Canouil for his work on quarto-highlight-text which forms the base of this Lua filter
-- See this repository for more information: https://github.com/mcanouil/quarto-highlight-text

local function change_text_openxml_pptx(span, fontsize, color, bg_color)
  local spec = '<a:r><a:rPr '
  
  if fontsize ~= nil then
    spec = spec .. 'sz = "' .. fontsize .. '00" dirty="0">'
  else
    spec = spec .. 'dirty="0">'
  end
  
  if color ~= nil then
    spec = spec .. '<a:solidFill><a:srgbClr val="' .. color:gsub("^#", "") .. '"/></a:solidFill>'
  end

  if bg_color ~= nil then
    spec = spec .. '<a:highlight><a:srgbClr val="' .. bg_color:gsub("^#", "") .. '"/></a:highlight>'
  end
  
  spec = spec .. '</a:rPr><a:t>'
  
  local span_content_string = ""
  for i, inline in ipairs(span.content) do
    span_content_string = span_content_string .. pandoc.utils.stringify(inline)
  end
  
  return pandoc.RawInline('openxml', spec .. span_content_string .. '</a:t></a:r>')
end

function Span(span)
  local fontsize = span.attributes['fontsize']
  local color = span.attributes['color']
  local bg_color = span.attributes['bg-color']
  if fontsize == nil and color == nil and bg_color == nil then return span end
  return change_text_openxml_pptx(span, fontsize, color, bg_color)  
end
