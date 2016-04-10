# \ -s puma

Dir.glob('./{models,controllers,services,values}/*.rb').each do |file|
  require file
end
run CanvasVisualizationAPI
