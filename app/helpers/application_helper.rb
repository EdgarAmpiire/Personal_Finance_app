module ApplicationHelper
  def nav_link(label, path)
    base = "flex items-center gap-2 rounded px-3 py-2 text-sm"
    active = current_page?(path)

    classes =
      if active
        "#{base} bg-slate-800 text-white"
      else
        "#{base} text-slate-200 hover:bg-slate-800 hover:text-white"
      end

    link_to label, path, class: classes
  end
end
