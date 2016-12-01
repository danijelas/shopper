module ApplicationHelper
  
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def currency_codes
    Money::Currency.table.values.map{|a| a[:iso_code]}
  end
  # def nested_attributes_for(form_builder, *args)
  #   options = args.extract_options!
  #   javascript_tag do
  #     content = ""
  #     args.each do |association|
  #       content << "\nvar #{association}_template='#{generate_template(form_builder, association.to_sym, options)}';"
  #     end
  #     raw content
  #   end
  # end

  # def generate_html(form_builder, method, options = {})
  #   options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
  #   options[:partial] ||= method.to_s.singularize
  #   options[:form_builder_local] ||= :f
  #   options[:locals] ||= {}

  #   form_builder.fields_for(method, options[:object], child_index: 'NEW_RECORD') do |f|
  #     render(partial: options[:partial], locals: { options[:form_builder_local] => f }.merge(options[:locals]))
  #   end
  # end

  # def generate_template(form_builder, method, options = {})
  #   escape_javascript generate_html(form_builder, method, options)
  # end

  # def remove_link_unless_new_record(name, fields, style="remove_child")
  #   out = ''
  #   unless fields.object.new_record?
  #     out << fields.hidden_field(:_destroy)
  #   end
  #   out << link_to(name, 'javascript:void(0);', class: style)
  #   raw out
  # end

  # def add_child_link(name, association, style="add_child")
  #   link_to(name, 'javascript:void(0);', class: style, data: { association: association })
  # end 
end