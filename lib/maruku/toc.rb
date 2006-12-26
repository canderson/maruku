require 'rexml/document'

class MDElement
	class Section
		def inspect(indent=1)
			s = ""
			if @header_element
				s +=  "\_"*indent +  "(#{@section_level})>\t #{@section_number.join('.')} : "
				s +=  @header_element.children_to_s + " (id: '#{@header_element.meta[:id]}')\n"
			else
				s += "Master\n"
			end
			
			@section_children.each do |c|
				s+=c.inspect(indent+1)
			end
			s
		end
		
		# Numerate this section and its children
		def numerate(a=[])
			self.section_number = a
			section_children.each_with_index do |c,i|
				c.numerate(a.clone.push(i+1))
			end
		end
		
		include REXML
		# Creates an HTML toc.
		# Call this on the root 
		def to_html
			div = Element.new 'div'
			div.attributes['class'] = 'maruku_toc'
			div << create_toc
			div
		end
		
		def create_toc
			ul = Element.new 'ul'
			# let's remove the bullets
			ul.attributes['style'] = 'list-style: none;' 
			@section_children.each do |c|
				li = Element.new 'li'
				if span = c.header_element.render_section_number
					li << span
				end
				a = c.header_element.wrap_as_element('a')
					a.delete_attribute 'id'
					a.attributes['href'] = "##{c.header_element.meta[:id]}"
				li << a
				li << c.create_toc if c.section_children.size>0
				ul << li
			end
			ul
		end

		# Creates a latex toc.
		# Call this on the root 
		def to_latex
			to_latex_rec + "\n\n"
		end
		
		def to_latex_rec
			s = ""
			@section_children.each do |c|
				s += "\\noindent"
				number = c.header_element.section_number
				s += number if number
					text = c.header_element.children_to_latex
					id = c.header_element.meta[:id]
				s += "\\hyperlink{#{id}}{#{text}}"
				s += "\\dotfill \\pageref*{#{id}} \\linebreak\n"
				s += c.to_latex_rec  if c.section_children.size>0

			end
			s
		end
		
	end
end


class MDElement
	
	
	def create_toc
		stack = []
		
		# the ancestor section
		s = Section.new
		s.section_level = 0

		stack.push s
	
		i = 0;
		while i < @children.size
			
			while i < @children.size 
				if @children[i].node_type == :header
					level = @children[i].meta[:level]
					break if level <= stack.last.section_level+1
				end
				
				stack.last.immediate_children.push @children[i]
				i += 1
			end

			break if i>=@children.size
			
			header = @children[i]
			level = header.meta[:level]
			
			if level > stack.last.section_level
				# this level is inside
				
				s2 = Section.new
				s2.section_level = level
				s2.header_element = header
				header.meta[:section] = s2
				
				stack.last.section_children.push s2
				stack.push s2
				
				i+=1
			elsif level == stack.last.section_level
				# this level is a sibling
				stack.pop
			else 
				# this level is a parent
				stack.pop
			end
			
		end

		# If there is only one big header, then assume
		# it is the master
		if s.section_children.size == 1
			s = s.section_children.first
		end
		
		# Assign section numbers
		s.numerate
	
		s
	end
	
end