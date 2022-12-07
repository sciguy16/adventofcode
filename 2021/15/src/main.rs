#![feature(generic_const_exprs)]
#![allow(incomplete_features)]
use nalgebra::DMatrix;
use petgraph::algo::dijkstra;
use petgraph::Graph;
use std::str::FromStr;

#[derive(PartialEq, Eq, Debug)]
struct CavernMatrix<const R: usize, const C: usize> {
    inner: DMatrix<u32>,
}

impl<const R: usize, const C: usize> FromStr for CavernMatrix<R, C> {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let m = DMatrix::from_iterator(
            C,
            R,
            s.chars().filter_map(|c| c.to_digit(10)),
        )
        .transpose();
        Ok(Self { inner: m })
    }
}

impl<const R: usize, const C: usize> CavernMatrix<R, C> {
    fn embiggen(&self) -> CavernMatrix<{ R * 5 }, { C * 5 }> {
        let rows = R * 5;
        let cols = C * 5;
        let mut inner = DMatrix::zeros(rows, cols);

        // Copy the original matrix into the new one in a tiling pattern,
        // adding the increase factor as appropriate
        for row_copy in 0..5 {
            for col_copy in 0..5 {
                //println!("Starting copy ({},{})", row_copy, col_copy);
                for r in 0..R {
                    for c in 0..C {
                        if row_copy == 0 && col_copy == 0 {
                            inner[(r, c)] = self.inner[(r, c)];
                        } else if row_copy == 0 && col_copy > 0 {
                            inner[(r, c + C * col_copy)] = match inner
                                [(r + R * row_copy, c + C * (col_copy - 1))]
                                + 1
                            {
                                10 => 1,
                                n => n,
                            };
                        } else if row_copy > 0 && col_copy == 0 {
                            inner[(r + R * row_copy, c)] = match inner
                                [(r + R * (row_copy - 1), c + C * col_copy)]
                                + 1
                            {
                                10 => 1,
                                n => n,
                            };
                        } else {
                            // not on top row or column, so taking the previous
                            // row should be ok
                            inner[(r + R * row_copy, c + C * col_copy)] =
                                match inner
                                    [(r + R * (row_copy - 1), c + C * col_copy)]
                                    + 1
                                {
                                    10 => 1,
                                    n => n,
                                };
                        }
                    }
                    //None::<()>.unwrap();
                }
            }
        }

        CavernMatrix { inner }
    }
}

fn index(r: usize, c: usize) -> u32 {
    (r << 8 | c) as u32
}

struct CavernGraph<const R: usize, const C: usize> {
    inner: Graph<(usize, usize), u32>,
    dimension: usize,
}

impl<const R: usize, const C: usize> From<&CavernMatrix<R, C>>
    for CavernGraph<R, C>
{
    fn from(mat: &CavernMatrix<R, C>) -> Self {
        assert_eq!(R, C);
        // Only consider movements down and left, because any other
        // movement will be strictly longer than the shortest route
        // The above is false, we must consider all movements.

        let mut edges = Vec::<(u32, u32, u32)>::new();
        for r in 0..R {
            for c in 0..C {
                // insert edges from current (r, c) to the elements
                // immediately below and immediately right
                // Also insert corresponding reverse edges
                let cost_reverse = mat.inner[(r, c)];
                if r < R - 1 {
                    let cost_down = mat.inner[(r + 1, c)];
                    edges.push((index(r, c), index(r + 1, c), cost_down));
                    edges.push((index(r + 1, c), index(r, c), cost_reverse));
                }
                if c < C - 1 {
                    let cost_right = mat.inner[(r, c + 1)];
                    edges.push((index(r, c), index(r, c + 1), cost_right));
                    edges.push((index(r, c + 1), index(r, c), cost_reverse));
                }
            }
        }
        let inner = Graph::from_edges(edges.iter());
        Self {
            inner,
            dimension: R,
        }
    }
}

fn part_one<const R: usize, const C: usize>(
    graph: &CavernGraph<R, C>,
) -> usize {
    //println!("{:?}", graph.inner);

    let start = index(0, 0);
    let end = index(graph.dimension - 1, graph.dimension - 1);
    let node_map =
        dijkstra(&graph.inner, start.into(), Some(end.into()), |e| {
            *e.weight()
        });
    //println!("start: {start}, end: {end} = 0x{:x}", end);
    //println!("node map: {:?}", node_map);
    let cost = *node_map.get(&end.into()).unwrap();
    //println!("cost: {}", cost);
    assert!(cost < 368 || R > 100, "Your answer is too high");
    assert!(cost > 939 || R <= 100, "Your answer is too low");
    cost as usize
}

fn main() {
    let input = include_str!("../input.txt");
    let data: CavernMatrix<100, 100> = input.parse().unwrap();
    let graph = CavernGraph::from(&data);
    let ans = part_one(&graph);
    println!("part one: {ans}");
    let bigger = data.embiggen();
    let graph = CavernGraph::from(&bigger);
    println!("graph dimension: {}", graph.dimension);
    let ans = part_one(&graph);
    println!("part two: {ans}");
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"#;

    const EMBIGGENED: &str = r#"11637517422274862853338597396444961841755517295286
13813736722492484783351359589446246169155735727126
21365113283247622439435873354154698446526571955763
36949315694715142671582625378269373648937148475914
74634171118574528222968563933317967414442817852555
13191281372421239248353234135946434524615754563572
13599124212461123532357223464346833457545794456865
31254216394236532741534764385264587549637569865174
12931385212314249632342535174345364628545647573965
23119445813422155692453326671356443778246755488935
22748628533385973964449618417555172952866628316397
24924847833513595894462461691557357271266846838237
32476224394358733541546984465265719557637682166874
47151426715826253782693736489371484759148259586125
85745282229685639333179674144428178525553928963666
24212392483532341359464345246157545635726865674683
24611235323572234643468334575457944568656815567976
42365327415347643852645875496375698651748671976285
23142496323425351743453646285456475739656758684176
34221556924533266713564437782467554889357866599146
33859739644496184175551729528666283163977739427418
35135958944624616915573572712668468382377957949348
43587335415469844652657195576376821668748793277985
58262537826937364893714847591482595861259361697236
96856393331796741444281785255539289636664139174777
35323413594643452461575456357268656746837976785794
35722346434683345754579445686568155679767926678187
53476438526458754963756986517486719762859782187396
34253517434536462854564757396567586841767869795287
45332667135644377824675548893578665991468977611257
44961841755517295286662831639777394274188841538529
46246169155735727126684683823779579493488168151459
54698446526571955763768216687487932779859814388196
69373648937148475914825958612593616972361472718347
17967414442817852555392896366641391747775241285888
46434524615754563572686567468379767857948187896815
46833457545794456865681556797679266781878137789298
64587549637569865174867197628597821873961893298417
45364628545647573965675868417678697952878971816398
56443778246755488935786659914689776112579188722368
55172952866628316397773942741888415385299952649631
57357271266846838237795794934881681514599279262561
65719557637682166874879327798598143881961925499217
71484759148259586125936169723614727183472583829458
28178525553928963666413917477752412858886352396999
57545635726865674683797678579481878968159298917926
57944568656815567976792667818781377892989248891319
75698651748671976285978218739618932984172914319528
56475739656758684176786979528789718163989182927419
67554889357866599146897761125791887223681299833479"#;

    #[test]
    fn test_part_1() {
        let inp: CavernMatrix<10, 10> = TEST_DATA.parse().unwrap();
        let graph = CavernGraph::from(&inp);
        let ans = part_one(&graph);
        assert_eq!(ans, 40);
    }

    #[test]
    fn test_part_2() {
        let inp: CavernMatrix<10, 10> = TEST_DATA.parse().unwrap();
        let bigger: CavernMatrix<50, 50> = inp.embiggen();
        let graph = CavernGraph::from(&bigger);
        let ans = part_one(&graph);
        assert_eq!(ans, 315);
    }

    #[test]
    fn test_embiggen() {
        let inp: CavernMatrix<10, 10> = TEST_DATA.parse().unwrap();
        let bigger: CavernMatrix<50, 50> = inp.embiggen();
        let to_compare: CavernMatrix<50, 50> = EMBIGGENED.parse().unwrap();

        println!("expected:");
        print!(
            "    {}",
            EMBIGGENED
                .lines()
                .next()
                .unwrap()
                .chars()
                .map(|c| format!("{c} "))
                .collect::<String>()
        );
        println!("{}", bigger.inner);
        assert_eq!(bigger, to_compare);
    }
}
