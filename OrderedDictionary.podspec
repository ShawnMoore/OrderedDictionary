Pod::Spec.new do |spec|
  spec.name = "OrderedDictionary"
  spec.version = "1.0.0"
  spec.summary = "Sample framework from blog post, not for real world use."
  spec.homepage = "https://github.com/ShawnMoore/OrderedDictionary"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Shawn Moore" => 'shawn.t.moore@icloud.com' }

  spec.platform = :ios, "9.3"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/ShawnMoore/OrderedDictionary.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "OrderedDictionary/**/*.{h,swift}"

end
