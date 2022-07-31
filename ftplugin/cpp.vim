setlocal cindent
setlocal cino=g0:0

" 同階層に同名で別拡張子のファイルがあれば開く
if !exists('*s:OpenAnotherExt')
	function s:OpenAnotherExt(ext)
		let filename = expand('%:p:r').a:ext
		if filereadable(filename)
			execute 'vnew '.filename
		else
			echomsg 'Not found '.filename
		endif
	endfunction
endif

command! -buffer Src call s:OpenAnotherExt('.cpp')
command! -buffer Inc call s:OpenAnotherExt('.h')
command! -buffer Inl call s:OpenAnotherExt('.inl')

" 名前空間の出力
if !exists('*s:WriteNamespace')
	function! s:WriteNamespace(...)
		setlocal paste

		for ns in a:000
			execute "normal i"."namespace ".ns."{\n"
		endfor

		for ns in reverse(copy(a:000))
			execute "normal i"."} // namespace ".ns."\n"
		endfor

		setlocal nopaste
	endfunction
endif

command! -buffer -nargs=+ NS call s:WriteNamespace(<f-args>)
