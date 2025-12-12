ex2:
list of edges for graph bridge
aatat
edge one: aat
edge 2: tat
one edge per line 

# Exercise 1

## Step 1.1
(1million*3) * 100 = 30k
30k reads are needed to sequence.

## Step 1.4
200,000/ 1million *100 = 20%
20% of the genome has not been sequences
Niether distribution matches fits the data perfectly but the Poisson expectation fits it just a bit better

## Step 1.5
1. 0% of the genome has not been sequenced.
2. The poisson distribution fits the data the best and the normal distribution fits the well.

## Step 1.6
1. None of the genome has been sequenced.
2. Both the poisson and normal distribution fit the data well and they look about the same.

## Step 2.4
dot -Tpng debruijn_graph.dot -o ex2_digraph.png

## Step 2.5
ATTCTTATTGATTTAT

## Step 2.5
To accurately recustruct the sequence of the genome it would take complete coverage of the genome so that every kmer of the fenome appears in at least one read. Longer k-mers would also help as well.