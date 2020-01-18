
struct Vector3{T}
    x::T
    y::T
    z::T
end

struct Vector4{T}
    x::T
    y::T
    z::T
    w::T
end

abstract type AbstractEntity end

mutable struct GfxState
    Window::Union{GLFW.Window, Int}
    WindowResolution::Tuple{Int,Int}
    
    ShaderList       #::Dict{AbstractString, Any}
    VertexDataList   #::Dict{AbstractString, Any}
end

mutable struct EngineState
    Name::AbstractString
    Gfx::GfxState
    Entities         #::Array{AbstractEntity,1}

    KeyState

    TimeCurrent
    TimeDelta
    FrameCount::Int64

end