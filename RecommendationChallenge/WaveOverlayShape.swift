//
//  WaveOverlayShape.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 15/11/23.
//

import Foundation
import SwiftUI

struct WaveOverlayShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Ajusta estos valores para cambiar la posición y la forma de la onda
        let waveDepth = rect.height * 0.2 // Profundidad de la onda desde la parte superior del rectángulo
        let waveLength = rect.width // La longitud completa del rectángulo para una onda más suave

        // Comienza en la esquina superior izquierda
        path.move(to: CGPoint(x: 0, y: waveDepth))
        // Agrega una curva que llega hasta la mitad superior del rectángulo
        path.addCurve(to: CGPoint(x: waveLength / 2, y: waveDepth),
                      control1: CGPoint(x: waveLength * 0.25, y: 0),
                      control2: CGPoint(x: waveLength * 0.25, y: waveDepth))
        // Continúa la curva hasta el final del rectángulo
        path.addCurve(to: CGPoint(x: waveLength, y: waveDepth),
                      control1: CGPoint(x: waveLength * 0.75, y: waveDepth),
                      control2: CGPoint(x: waveLength * 0.75, y: 0))
        // Línea hacia abajo para cerrar el rectángulo
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        // Línea horizontal hacia la izquierda en la parte inferior del rectángulo
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        // Cierra la subruta conectando con el punto inicial
        path.closeSubpath()

        return path
    }
}
