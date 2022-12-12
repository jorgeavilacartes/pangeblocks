configfile: "params.yaml"
from pathlib import Path
import pandas as pd

# PATH_MSAS = Path(config["PATH_MSAS"]).rglob("*fa")
PATH_MSAS = pd.read_csv("../data/output-old-experiments.tsv", sep="\t")
NAMES=[Path(path).stem for path in PATH_MSAS["path_msa"]] # msas names

rule all:
    input:
        expand("output-sub/max_blocks/stats/{name_msa}.tsv", name_msa=NAMES),
        expand("output-sub/block_decomposition/{name_msa}.json", name_msa=NAMES)

rule compute_blocks:
    input:
        "/home/avila/data/msas/{name_msa}.fa"
    output: 
        "output-sub/max_blocks/{name_msa}.json"
    shell:
        "python src/compute_blocks.py {input} --output {output} --multi"

rule analyze_blocks:
    input:
        "output-sub/max_blocks/{name_msa}.json"
    output:
        "output-sub/max_blocks/stats/{name_msa}.tsv"
    shell: 
        "python analyze_blocks.py {input} --output {output}"

rule decompose_blocks:
    input:
        "output-sub/max_blocks/{name_msa}.json"
    output:
        "output-sub/block_decomposition/{name_msa}.json",
        "output-sub/block_decomposition/stats/{name_msa}.tsv"
    shell:
        "python decompose_blocks.py {input} --output {output[0]} --output-stats {output[1]}"