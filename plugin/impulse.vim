function! ReloadImpulse()
lua << EOF
	for k in pairs(package.loaded) do
		if k:match("^impulse") then package.loaded[k] = nil end
	end

	require("impulse").setup {}
EOF
endfunction

" dev only, eventually let people map this on their own instead
nnoremap <leader>pra :call ReloadImpulse()<CR>
nnoremap <leader>ptt :lua require("impulse").menu_search()<CR>
nnoremap <leader>pfl :lua require("impulse").follow_link()<CR>
