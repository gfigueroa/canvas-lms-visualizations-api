# \ -s puma

Dir.glob('./{models,helpers,controllers,services,operations,values}/*.rb')
  .each do |file|
  require file
end
run CanvasVisualizationApp
