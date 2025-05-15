local function is_truthy(val)
  if val == nil then return false end
  local lowered = tostring(val):lower()
  return lowered ~= "false" and lowered ~= "0"
end

local function change_text_openxml_pptx(span, bold, italic, underline, fontsize, color, bg_color)
  local attrs = {}

  if is_truthy(bold) then
    table.insert(attrs, 'b="1"')
  end

  if is_truthy(italic) then
    table.insert(attrs, 'i="1"')
  end

  if is_truthy(underline) then
    table.insert(attrs, 'u="sng"') -- "sng" means single underline in OpenXML
  end

  if fontsize ~= nil then
    table.insert(attrs, 'sz="' .. fontsize .. '00"')
  end

  table.insert(attrs, 'dirty="0"') -- Always included

  local spec = '<a:r><a:rPr ' .. table.concat(attrs, " ") .. '>'

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
  local attrs = span.attributes
  local classes = span.classes
  local bold = attrs["bold"] or (classes:includes("bold") and "true")
  local italic = attrs["italic"] or (classes:includes("italic") and "true")
  local underline = attrs["underline"] or (classes:includes("underline") and "true")
  local fontsize = attrs["fontsize"] or attrs["font-size"]
  local color = attrs["color"]
  local bg_color = attrs["bg-color"]
  if bold == nil and italic == nil and underline == nil and fontsize == nil and color == nil and bg_color == nil then return span end
  return change_text_openxml_pptx(span, bold, italic, underline, fontsize, color, bg_color)
end