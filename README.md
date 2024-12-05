´´´python
import gensim
from gensim.models import Word2Vec
from gensim.models.keyedvectors import KeyedVectors

# Étape 1 : Charger le modèle préentraîné (exemple avec Google News Word2Vec)
# Assurez-vous d'avoir téléchargé le modèle pré-entraîné en .bin
pretrained_model_path = "GoogleNews-vectors-negative300.bin"  # Chemin vers le fichier préentraîné
pretrained_wv = KeyedVectors.load_word2vec_format(pretrained_model_path, binary=True)

# Étape 2 : Charger un corpus personnalisé
# Exemple simple d'un corpus en texte brut
personal_corpus = [
    ["chat", "joue", "avec", "une", "souris"],
    ["chien", "court", "dans", "le", "parc"],
    ["le", "soleil", "brille", "aujourd'hui"]
]

# Étape 3 : Construire un vocabulaire à partir du corpus personnalisé
# On crée un modèle Word2Vec uniquement pour extraire le vocabulaire
temp_model = Word2Vec(sentences=personal_corpus, vector_size=300, min_count=1)
personal_vocab = set(temp_model.wv.index_to_key)

# Étape 4 : Intersection entre le vocabulaire préentraîné et celui du corpus personnel
# Garder uniquement les mots en commun avec le modèle préentraîné
pretrained_wv.intersect_word2vec_format(
    vocab=personal_vocab,
    lockf=1.0  # Mettre lockf > 0 pour permettre un réentraînement
)

# Étape 5 : Ré-entraîner le modèle avec le corpus personnalisé
# Créer un modèle Word2Vec en utilisant les vecteurs du modèle préentraîné
final_model = Word2Vec(vector_size=300, min_count=1)
final_model.build_vocab(personal_corpus)
final_model.wv.vectors_lockf = pretrained_wv.vectors_lockf
final_model.wv.add_vectors(pretrained_wv.index_to_key, pretrained_wv.vectors)
final_model.train(personal_corpus, total_examples=len(personal_corpus), epochs=10)

# Étape 6 : Utiliser le modèle ajusté
# Exemple de similarité
similarity = final_model.wv.similarity("chat", "chien")
print(f"Similarité entre 'chat' et 'chien' : {similarity:.4f}")

# Exemple de mots proches
print("Mots proches de 'chat' :", final_model.wv.most_similar("chat"))

´´´
