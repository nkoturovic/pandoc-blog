#!/usr/bin/env lua

 -- Override code blocks to use \begin{lstlisting}[language=Rust]...\end{lstlisting}
-- for beamer/latex writers when ```Rust is used due to following unresolved issue:
-- https://github.com/jgm/pandoc/issues/4116
local function CodeBlock(element)
    if element.classes[1] == "rust" then
        return pandoc.RawBlock("latex", "\n\\begin{lstlisting}[language=Rust]\n"..element.text.."\n\\end{lstlisting}\n")
    else
        return element
    end
end

-- Override headers to make all beamer frames fragile, since any frane with lstlisting
-- environments will halt compilation if the frame is not marked as fragile.
function Header(element)
	if FORMAT == 'beamer' then
		-- Check first that 'fragile' is not already present.
		local has_fragile = false
		for _, val in ipairs(element.classes) do
			if val == 'fragile' then
				has_fragile = true
				break
			end
		end

		-- If not found, add fragile to the list of classes.
		if not has_fragile then
			table.insert(element.classes, 'fragile')
		end

		-- NOTE: pass the remaining work to pandoc, noting that 2.5 and below
		-- may duplicate the 'fragile' specifier.  Duplicated fragile does *not*
		-- cause compile errors.
		return element
	end
end
return {
	{ CodeBlock = CodeBlock },
	{ Header = Header }
}
