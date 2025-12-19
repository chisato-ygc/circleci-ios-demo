//
//  TaskStatsView.swift
//  CircleCIDemoApp
//
//  Statistics display for tasks
//

import SwiftUI

/// A view displaying task completion statistics
/// 
/// Demonstrates:
/// - Custom shapes
/// - Animations
/// - Computed properties
struct TaskStatsView: View {
    let tasks: [Task]
    
    var body: some View {
        HStack(spacing: 20) {
            // Progress ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: tasks.completionPercentage / 100)
                    .stroke(
                        Color.green,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: tasks.completionPercentage)
                
                VStack(spacing: 0) {
                    Text("\(Int(tasks.completionPercentage))%")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Done")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 70, height: 70)
            
            // Stats cards
            VStack(alignment: .leading, spacing: 8) {
                StatRow(
                    icon: "checkmark.circle.fill",
                    color: .green,
                    label: "Completed",
                    value: tasks.completedCount
                )
                
                StatRow(
                    icon: "clock.fill",
                    color: .orange,
                    label: "Pending",
                    value: tasks.pendingCount
                )
                
                StatRow(
                    icon: "list.bullet",
                    color: .blue,
                    label: "Total",
                    value: tasks.count
                )
            }
            
            Spacer()
        }
    }
}

/// A single row in the stats display
struct StatRow: View {
    let icon: String
    let color: Color
    let label: String
    let value: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("\(value)")
                .font(.callout)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Preview

#Preview {
    TaskStatsView(tasks: Task.sampleTasks)
        .padding()
}

