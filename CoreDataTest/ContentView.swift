//
//  ContentView.swift
//  CoreDataTest
//
//  Created by Paulus Michael on 16/09/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
   @Environment(\.managedObjectContext) private var viewContext
   
   @FetchRequest(
      entity: FruitEntity.entity(),
      sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)])
   var fruits: FetchedResults<FruitEntity>
   
   @State var textFieldText: String = ""
   var color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
   
   var body: some View {
      NavigationView {
         VStack(spacing: 20) {
            
            TextField("Add fruit here...", text: $textFieldText)
               .font(.headline)
               .padding(.leading)
               .frame(maxWidth: .infinity)
               .frame(height: 55)
               .background(Color(color))
               .clipShape(.rect(cornerRadius: 12))
               .padding(.horizontal)
            
            Button(action: {
               addItem()
            }, label: {
               Text("Submit")
                  .font(.headline)
                  .foregroundStyle(.white)
                  .frame(maxWidth: .infinity)
                  .frame(height: 55)
                  .background(.blue)
                  .clipShape(.rect(cornerRadius: 10))
            })
            .padding(.horizontal)
            
            List {
               ForEach(fruits) { fruit in
                  NavigationLink {
                     Text(fruit.name ?? "")
                  } label: {
                     Text(fruit.name ?? "")
                  }
               }
               .onDelete(perform: deleteItems)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Fruits")
            .toolbar {
               //            ToolbarItem(placement: .navigationBarTrailing) {
               //               EditButton()
               //            }
               ToolbarItem {
                  Button(action: addItem) {
                     Label("Add Item", systemImage: "plus")
                  }
               }
            }
            
            Text("Select an item")
         }
      }
   }
   
   private func addItem() {
      withAnimation {
         let newFruit = FruitEntity(context: viewContext)
         newFruit.name = textFieldText
         
         saveItems()
         
         textFieldText = ""
      }
   }
   
   private func deleteItems(offsets: IndexSet) {
      withAnimation {
         guard let index = offsets.first else {return}
         let fruitEntity = fruits[index]
         viewContext.delete(fruitEntity)
         
         //         offsets.map { items[$0] }.forEach(viewContext.delete)
         
         saveItems()
      }
   }
   
   private func saveItems(){
      do {
         try viewContext.save()
      } catch {
         // Replace this implementation with code to handle the error appropriately.
         // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         let nsError = error as NSError
         fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
   }
}

private let itemFormatter: DateFormatter = {
   let formatter = DateFormatter()
   formatter.dateStyle = .short
   formatter.timeStyle = .medium
   return formatter
}()

#Preview {
   ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
