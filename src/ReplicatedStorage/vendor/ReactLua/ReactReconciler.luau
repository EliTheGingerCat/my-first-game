local module = require(script.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('react-reconciler'))
export type Dispatcher = module.Dispatcher
export type Fiber = module.Fiber
export type FiberRoot = module.FiberRoot
export type UpdateQueue<T> = module.UpdateQueue<T>
export type RootTag = module.RootTag
return module
