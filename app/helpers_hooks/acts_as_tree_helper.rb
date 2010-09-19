module ApplicationHelper
  # Renders a node and its children. The caller must provide a block which
  # actually renders each node.
  def html_tree(node, level = 0, wrapper = :li, children_wrapper = :ul, &block)
    ret, wrapper_options = block.call(node, level)
    unless node.children.empty?
      s = ''.html_safe
      node.children.each { |n| s << html_tree(n, level + 1, wrapper, children_wrapper, &block) }
      s = content_tag(children_wrapper, s) unless children_wrapper.blank?
      ret << s
    end
    ret = content_tag(wrapper, ret, wrapper_options) unless wrapper.blank?
    ret
  end

  def nodes_for_select(klass, method, selected_node_id, space_per_indent = 2)
    ret = "<option value=''>---</option>".html_safe
    klass.tops.each do |t|
      ret << html_tree(t, 0, :option, nil) do |n, level|
        ["&nbsp;"*level*space_per_indent + h(n.send(method)), {:value => n.id, :selected => (n.id == selected_node_id)? 'selected' : nil}]
      end
    end
    ret
  end
end
