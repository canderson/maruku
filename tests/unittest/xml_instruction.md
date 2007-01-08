Directives should be preserved.
*** Parameters: ***
{}
*** Markdown input: ***

<? noTarget?> 
<?php ?> 
<?xml ?> 
<?mrk ?>

Targets <? noTarget?> <?php ?> <?xml ?> <?mrk ?>

Inside: <? puts "Inside: Hello" ?>{exec} last


*** Output of inspect ***
md_el(:document,[
	md_el(:xml_instr,[],{:code=>" noTarget",:target=>""},[]),
	md_el(:xml_instr,[],{:code=>"",:target=>"php"},[]),
	md_el(:xml_instr,[],{:code=>"",:target=>"xml"},[]),
	md_el(:xml_instr,[],{:code=>"",:target=>"mrk"},[]),
	md_par([
		"Targets ",
		md_el(:xml_instr,[],{:code=>"noTarget",:target=>""},[]),
		" ",
		md_el(:xml_instr,[],{:code=>"",:target=>"php"},[]),
		" ",
		md_el(:xml_instr,[],{:code=>"",:target=>"xml"},[]),
		" ",
		md_el(:xml_instr,[],{:code=>"",:target=>"mrk"},[])
	]),
	md_par([
		"Inside: ",
		md_el(:xml_instr,[],{:code=>"puts \"Inside: Hello\"",:target=>""},[[:ref, "exec"]]),
		md_ial([[:ref, "exec"]]),
		" last"
	])
],{},[])
*** Output of to_html ***
<? noTarget?><?php ?><?xml ?><?mrk ?>
<p>Targets <? noTarget?> <?php ?> <?xml ?> <?mrk ?></p>

<p>Inside: <? puts "Inside: Hello"?> last</p>

*** Output of to_latex ***
Targets    

Inside:  last


*** Output of to_md ***
Targets

Inside: last


*** Output of to_s ***
Targets    Inside:  last
*** EOF ***



	OK!



*** Output of Markdown.pl ***
<p><? noTarget?> 
<?php ?> 
<?xml ?> 
<?mrk ?></p>

<p>Targets <? noTarget?> <?php ?> <?xml ?> <?mrk ?></p>

<p>Inside: <? puts "Inside: Hello" ?>{exec} last</p>

*** Output of Markdown.pl (parsed) ***
<p
     >     <? noTarget?>     <?php ?>     <?xml ?>     <?mrk ?></p
   ><p>Targets      <? noTarget?>     <?php ?>     <?xml ?>     <?mrk ?></p
   ><p>Inside:      <? puts "Inside: Hello"?>{exec} last</p
 >