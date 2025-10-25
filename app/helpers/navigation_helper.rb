module NavigationHelper
  def nav_link_class(path)
    # Skip active state for hash placeholders
    return "border-transparent text-gray-500 hover:border-green-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium" if path == "#"

    current_page = request.path

    if current_page == path
      "border-green-500 text-gray-900 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
    else
      "border-transparent text-gray-500 hover:border-green-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
    end
  end

  def mobile_nav_link_class(path)
    # Skip active state for hash placeholders
    return "border-transparent text-gray-600 hover:bg-gray-50 hover:border-green-300 hover:text-gray-800 block pl-3 pr-4 py-2 border-l-4 text-base font-medium" if path == "#"

    current_page = request.path

    if current_page == path
      "bg-green-50 border-green-500 text-green-700 block pl-3 pr-4 py-2 border-l-4 text-base font-medium"
    else
      "border-transparent text-gray-600 hover:bg-gray-50 hover:border-green-300 hover:text-gray-800 block pl-3 pr-4 py-2 border-l-4 text-base font-medium"
    end
  end
end
