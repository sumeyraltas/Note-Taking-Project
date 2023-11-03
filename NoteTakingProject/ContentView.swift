import SwiftUI

struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var isAddingNote = false
    @State private var newNoteTitle = ""
    @State private var mainTitle = "MY NOTES"
    @State private var newNoteContent = ""
    @State private var isDarkMode = false

    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteDetail(note: note, isDarkMode: $isDarkMode)) {
                        Text(note.title)
                            .foregroundColor(isDarkMode ? .white : .black)
                    }
                }
                .onDelete(perform: deleteNote)
            }
          
            .navigationBarItems(leading:
                Button(action: {
                    isDarkMode.toggle()
                }) {
                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                },
                trailing:
                Button(action: {
                    isAddingNote = true
                }) {
                    Image(systemName: "plus")
                }
            )  .navigationBarTitle(mainTitle)
            .background(isDarkMode ? Color.black : Color.white)
        }
        .sheet(isPresented: $isAddingNote) {
            NavigationView {
                Form {
                    Section(header: Text("New Note")) {
                        TextField("Title", text: $newNoteTitle)
                        TextEditor(text: $newNoteContent)
                    }
                }
                .navigationBarTitle("Add Note")
                .navigationBarItems(leading:
                    Button("Cancel") {
                        isAddingNote = false
                    },
                    trailing:
                    Button("Save") {
                        let newNote = Note(title: newNoteTitle, content: newNoteContent)
                        notes.append(newNote)
                        isAddingNote = false
                        newNoteTitle = ""
                        newNoteContent = ""
                    }
                )
            }
        }
        .environment(\.editMode, .constant(EditMode.active))
    }
    
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Note: Identifiable {
    let id = UUID()
    var title: String
    var content: String
}

struct NoteDetail: View {
    var note: Note
    @Binding var isDarkMode: Bool // Add a binding to isDarkMode

    var body: some View {
        VStack {
            Text(note.title)
                .font(.title)
                .foregroundColor(isDarkMode ? .white : .black)
            
            Text(note.content)
                .padding()
                .foregroundColor(isDarkMode ? .white : .black)
            Spacer()
        }
        .navigationTitle("Note Detail")
    }
}
